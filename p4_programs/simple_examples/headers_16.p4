/*
Copyright (c) 2015-2016 by The Board of Trustees of the Leland
Stanford Junior University.  All rights reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


 Author: Lisa Yan (yanlisa@stanford.edu)
*/

header hop_metadata_t {
        bit<12> vrf;
        bit<64> ipv6_prefix;
        bit<16> next_hop_index;
        bit<16> mcast_grp;
        bit<4> urpf_fail;
        bit<8> drop_reason;
}

header ethernet_t {
        bit<48> dstAddr;
        bit<48> srcAddr;
        bit<16> etherType;
}

header vlan_tag_t {
        bit<3> pcp;
        bit<1> cfi;
        bit<12> vid;
        bit<16> etherType;
}

header mpls_t {
        bit<20> label;
        bit<3> exp;
        bit<1> bos;
        bit<8> ttl;
}

header ipv4_t {
        bit<4> version;
        bit<4> ihl;
        bit<8> diffserv;
        bit<16> totalLen;
        bit<16> identification;
        bit<3> flags;
        bit<13> fragOffset;
        bit<8> ttl;
        bit<8> protocol;
        bit<16> hdrChecksum;
        bit<32> srcAddr;
        bit<32> dstAddr;
}

header ipv6_t {
        bit<4> version;
        bit<8> trafficClass;
        bit<20> flowLabel;
        bit<16> payloadLen;
        bit<8> nextHdr;
        bit<8> hopLimit;
        bit<128> srcAddr;
        bit<128> dstAddr;
}


header icmp_t {
        bit<8> type_;
        bit<8> code;
        bit<16> hdrChecksum;
}

header tcp_t {
        bit<16> srcPort;
        bit<16> dstPort;
        bit<32> seqNo;
        bit<32> ackNo;
        bit<4> dataOffset;
        bit<3> res;
        bit<3> ecn;
        bit<6> ctrl;
        bit<16> window;
        bit<16> checksum;
        bit<16> urgentPtr;
}

header udp_t {
        bit<16> srcPort;
        bit<16> dstPort;
        bit<16> length_;
        bit<16> checksum;
}

header gre_t {
        bit<1> C;
        bit<1> R;
        bit<1> K;
        bit<1> S;
        bit<1> s;
        bit<3> recurse;
        bit<5> flags;
        bit<3> ver;
        bit<16> proto;
}

header arp_rarp_t {
        bit<16> hwType;
        bit<16> protoType;
        bit<8> hwAddrLen;
        bit<8> protoAddrLen;
        bit<16> opcode;
}

