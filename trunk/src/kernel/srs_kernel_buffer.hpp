/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2013-2020 Winlin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#ifndef SRS_KERNEL_BUFFER_HPP
#define SRS_KERNEL_BUFFER_HPP

#include <srs_core.hpp>

#include <sys/types.h>
#include <string>

class SrsBuffer;

// Encoder.
class ISrsEncoder
{
public:
    ISrsEncoder();
    virtual ~ISrsEncoder();
public:
    /**
     * get the number of bytes to code to.
     */
    // TODO: FIXME: change to uint64_t.
    virtual int nb_bytes() = 0;
    /**
     * encode object to bytes in SrsBuffer.
     */
    virtual srs_error_t encode(SrsBuffer* buf) = 0;
};

/**
 * the srs codec, to code and decode object with bytes:
 *      code: to encode/serialize object to bytes in buffer,
 *      decode: to decode/deserialize object from bytes in buffer.
 * we use SrsBuffer as bytes helper utility,
 * for example, to code:
 *      ISrsCodec* obj = ...
 *      char* bytes = new char[obj->size()];
 *
 *      SrsBuffer* buf = new SrsBuffer();
 *      buf->initialize(bytes, obj->size())
 *
 *      obj->encode(buf);
 * for example, to decode:
 *      int nb_bytes = ...
 *      char* bytes = ...
 *
 *      SrsBuffer* buf = new Srsbuffer();
 *      buf->initialize(bytes, nb_bytes);
 *
 *      ISrsCodec* obj = ...
 *      obj->decode(buf);
 * @remark protocol or amf0 or json should implements this interface.
 */
// TODO: FIXME: protocol, amf0, json should implements it.
class ISrsCodec : public ISrsEncoder
{
public:
    ISrsCodec();
    virtual ~ISrsCodec();
public:
    /**
     * decode object from bytes in SrsBuffer.
     */
    virtual srs_error_t decode(SrsBuffer* buf) = 0;
};

/**
 * bytes utility, used to:
 * convert basic types to bytes,
 * build basic types from bytes.
 * @remark the buffer never mange the bytes, user must manage it.
 */
class SrsBuffer
{
private:
    // current position at bytes.
    char* p;
    // the bytes data for buffer to read or write.
    char* bytes;
    // the total number of bytes.
    int nb_bytes;
public:
    // Create buffer with data b and size nn.
    // @remark User must free the data b.
    SrsBuffer(char* b, int nn);
    ~SrsBuffer();
public:
    // Get the data and head of buffer.
    //      current-bytes = head() = data() + pos()
    char* data();
    char* head();
    // Get the total size of buffer.
    //      left-bytes = size() - pos()
    int size();
    void set_size(int v);
    // Get the current buffer position.
    int pos();
    // Left bytes in buffer, total size() minus the current pos().
    int left();
    // Whether buffer is empty.
    bool empty();
    // Whether buffer is able to supply required size of bytes.
    // @remark User should check buffer by require then do read/write.
    // @remark Assert the required_size is not negative.
    bool require(int required_size);
public:
    // Skip some size.
    // @param size can be any value. positive to forward; nagetive to backward.
    // @remark to skip(pos()) to reset buffer.
    // @remark assert initialized, the data() not NULL.
    void skip(int size);
public:
    // Read 1bytes char from buffer.
    int8_t read_1bytes();
    // Read 2bytes int from buffer.
    int16_t read_2bytes();
    // Read 3bytes int from buffer.
    int32_t read_3bytes();
    // Read 4bytes int from buffer.
    int32_t read_4bytes();
    // Read 8bytes int from buffer.
    int64_t read_8bytes();
    // Read string from buffer, length specifies by param len.
    std::string read_string(int len);
    // Read bytes from buffer, length specifies by param len.
    void read_bytes(char* data, int size);
public:
    // Write 1bytes char to buffer.
    void write_1bytes(int8_t value);
    // Write 2bytes int to buffer.
    void write_2bytes(int16_t value);
    // Write 4bytes int to buffer.
    void write_4bytes(int32_t value);
    // Write 3bytes int to buffer.
    void write_3bytes(int32_t value);
    // Write 8bytes int to buffer.
    void write_8bytes(int64_t value);
    // Write string to buffer
    void write_string(std::string value);
    // Write bytes to buffer
    void write_bytes(char* data, int size);
};

/**
 * the bit buffer, base on SrsBuffer,
 * for exmaple, the h.264 avc buffer is bit buffer.
 */
class SrsBitBuffer
{
private:
    int8_t cb;
    uint8_t cb_left;
    SrsBuffer* stream;
public:
    SrsBitBuffer(SrsBuffer* b);
    ~SrsBitBuffer();
public:
    bool empty();
    int8_t read_bit();
};

#endif
