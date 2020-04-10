/*
Copyright 2019 RT-RK Computer Based Systems.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/


#include <core.p4>
#include <v1model.p4>

extern Register<T> {
    Register(bit<32> size);
    void read(in bit<32> index, out T value);
    void write(in bit<32> index, in T value);
}

////////////////////////////////////

const bit<16> TYPE_IPV4 = 0x800;

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

enum X {
   Field_0,
   Field_1,
   Field_2
}

enum Y {
   Field_00,
   Field_01,
   Field_02
}

struct metadata {
    bit<32> pkt_len;
    /* empty */
}

header H {
    bit<32> rtt;
}

struct headers {
    H   H_header;
}

const bit<32> MAX_ALLOWABLE_RTT = 30;

parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition accept;
    }

}

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {  }
}

control MyIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    Register<bit<32>>(1) input_traffic_bytes;
    Register<bit<32>>(1) sum_rtt_Tr;
    Register<bit<32>>(1) num_pkts_with_rtt;

    apply {
        @atomic{
            bit<32> input_traffic_bytes_tmp;
            input_traffic_bytes.read(0, input_traffic_bytes_tmp);
            input_traffic_bytes_tmp = input_traffic_bytes_tmp + meta.pkt_len;
            input_traffic_bytes.write(input_traffic_bytes_tmp, 0);
            if (hdr.H_header.rtt < MAX_ALLOWABLE_RTT) {
                bit<32> sum_rtt_Tr_tmp;
                sum_rtt_Tr.read(0, sum_rtt_Tr_tmp);
                sum_rtt_Tr_tmp = sum_rtt_Tr_tmp + hdr.H_header.rtt;
                sum_rtt_Tr.write(sum_rtt_Tr_tmp, 0);

                bit<32> num_pkts_with_rtt_tmp;
                num_pkts_with_rtt.read(0, num_pkts_with_rtt_tmp);
                num_pkts_with_rtt_tmp = num_pkts_with_rtt_tmp + 1;
                num_pkts_with_rtt.write(num_pkts_with_rtt_tmp, 0);
            }
        }
    } 
}


control MyEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {  }
}

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
     apply {  }
}

control MyDeparser(packet_out packet, in headers hdr) {
    apply { }
}

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
