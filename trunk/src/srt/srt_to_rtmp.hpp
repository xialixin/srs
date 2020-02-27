#ifndef SRT_TO_RTMP_H
#define SRT_TO_RTMP_H
#include <memory>
#include <string>
#include <thread>
#include <queue>
#include <mutex>
#include <condition_variable>
#include <srs_kernel_ts.hpp>
#include <srs_app_rtmp_conn.hpp>
#include <srs_raw_avc.hpp>
#include <srs_protocol_utility.hpp>
#include <unordered_map>

#include "srt_data.hpp"
#include "ts_demux.hpp"

#define SRT_VIDEO_MSG_TYPE 0x01
#define SRT_AUDIO_MSG_TYPE 0x02

typedef std::shared_ptr<SrsSimpleRtmpClient> RTMP_CONN_PTR;
typedef std::shared_ptr<SrsRawH264Stream> AVC_PTR;
typedef std::shared_ptr<SrsRawAacStream> AAC_PTR;

#define DEFAULT_VHOST "__default_host__"

class rtmp_client : public ts_media_data_callback_I, public std::enable_shared_from_this<rtmp_client> {
public:
    rtmp_client(std::string key_path);
    ~rtmp_client();

    void receive_ts_data(SRT_DATA_MSG_PTR data_ptr);
    int64_t get_last_live_ts();
    std::string get_url();

    srs_error_t connect();
    void close();

private:
    virtual void on_data_callback(SRT_DATA_MSG_PTR data_ptr, unsigned int media_type, uint64_t dts, uint64_t pts);

private:
    srs_error_t on_ts_video(std::shared_ptr<SrsBuffer> avs_ptr, uint64_t dts, uint64_t pts);
    srs_error_t on_ts_audio(std::shared_ptr<SrsBuffer> avs_ptr, uint64_t dts, uint64_t pts);
    virtual srs_error_t write_h264_sps_pps(uint32_t dts, uint32_t pts);
    virtual srs_error_t write_h264_ipb_frame(char* frame, int frame_size, uint32_t dts, uint32_t pts);
    virtual srs_error_t write_audio_raw_frame(char* frame, int frame_size, SrsRawAacStreamCodec* codec, uint32_t dts);

    int get_sample_rate(char sound_rate);

private:
    virtual srs_error_t rtmp_write_packet(char type, uint32_t timestamp, char* data, int size);

private:
    std::string _key_path;
    std::string _url;
    std::string _vhost;
    std::string _appname;
    std::string _streamname;
    TS_DEMUX_PTR _ts_demux_ptr;

private:
    AVC_PTR _avc_ptr;
    std::string _h264_sps;
    bool _h264_sps_changed;
    std::string _h264_pps;
    bool _h264_pps_changed;
    bool _h264_sps_pps_sent;
private:
    std::string _aac_specific_config;
    AAC_PTR _aac_ptr;
private:
    RTMP_CONN_PTR _rtmp_conn_ptr;
    bool _connect_flag;
    int64_t _last_live_ts;
};

typedef std::shared_ptr<rtmp_client> RTMP_CLIENT_PTR;

class srt2rtmp : public ISrsCoroutineHandler {
public:
    static std::shared_ptr<srt2rtmp> get_instance();
    srt2rtmp();
    virtual ~srt2rtmp();

    srs_error_t init();
    void release();

    void insert_data_message(unsigned char* data_p, unsigned int len, const std::string& key_path);
    void insert_ctrl_message(unsigned int msg_type, const std::string& key_path);

private:
    SRT_DATA_MSG_PTR get_data_message();
    virtual srs_error_t cycle();
    void handle_ts_data(SRT_DATA_MSG_PTR data_ptr);
    void handle_close_rtmpsession(const std::string& key_path);
    void check_rtmp_alive();

private:
    static std::shared_ptr<srt2rtmp> s_srt2rtmp_ptr;
    std::shared_ptr<SrsCoroutine> _trd_ptr;
    std::mutex _mutex;
    //std::condition_variable_any _notify_cond;
    std::queue<SRT_DATA_MSG_PTR> _msg_queue;

    std::unordered_map<std::string, RTMP_CLIENT_PTR> _rtmp_client_map;
    int64_t _lastcheck_ts;
};

#endif