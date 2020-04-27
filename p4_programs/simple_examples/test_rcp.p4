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

#include <core.p4>
#include <v1model.p4>

#include "defines.p4"
#include "headers_16.p4"

register<bit<32>>(1) count;

const bit<32> N = 30;

struct headers {
    ipv4_t                                  ipv4;
    ipv6_t                                  ipv6;
    vlan_tag_t[2]                           vlan_tag_;
    ethernet_t                              ethernet; 
}

struct metadata {
    hop_metadata_t        hop_metadata;
    bit<32>               sample;
}

action drop() {
}

action nop() {
}

action on_hit() {
}

action on_miss() {
}

// TODO: improve the parser
parser MyParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state parse_all_int_meta_value_heders {
        packet.extract(hdr.ethernet);
        packet.extract(hdr.ipv4);
        transition accept;
    }
    state start {
        transition accept;
    }
    
}


control process_ip(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    table check_ipv6 {
        key = {
        }
        actions = {
            on_hit;
            on_miss;
        }
        size = CHECK_IPV6_SIZE;
    }

    action set_ipv6_prefix_ucast(bit<64> ipv6_prefix){
        meta.hop_metadata.ipv6_prefix = ipv6_prefix;
    }

    action set_ipv6_prefix_xcast(bit<64> ipv6_prefix){
        meta.hop_metadata.ipv6_prefix = ipv6_prefix;
    }

    table ipv6_prefix {
        key = {
            hdr.ipv6.dstAddr : lpm;
        }
        actions = {
            set_ipv6_prefix_ucast;
            set_ipv6_prefix_xcast;
        }
        size = IPv6_PREFIX_SIZE;
    }

    action set_next_hop(bit<16> dst_index) {
	    meta.hop_metadata.next_hop_index = dst_index;
    }

    table ipv4_forwarding {
        key = {
            meta.hop_metadata.vrf : exact;
            hdr.ipv4.dstAddr : lpm;
        }
        actions = {
            set_next_hop;
        }
        size = IPV4_FORWARDING_SIZE;
    }
    
    table ipv6_forwarding {
        key = {
            meta.hop_metadata.vrf : exact;
            meta.hop_metadata.ipv6_prefix : exact;
            hdr.ipv6.dstAddr : lpm;
        }
        actions = {
            set_next_hop;
        }
        size = IPV6_FORWARDING_SIZE;
    }

    action set_multicast_replication_list(bit<16> mc_index) {
        meta.hop_metadata.mcast_grp = mc_index;
    }

    table ipv4_xcast_forwarding {
        key = {
            hdr.vlan_tag_[0].vid : exact;
            //Because multiple lpm is not supported hdr.ipv4.dstAddr : lpm;
            hdr.ipv4.srcAddr : lpm;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            set_multicast_replication_list;
        }
        size = IPV4_XCAST_FORWARDING_SIZE;
    }

    table ipv6_xcast_forwarding {
        key = {
            hdr.vlan_tag_[0].vid : exact;
            //Because multiple lpm is not supported  hdr.ipv6.dstAddr : lpm;
            hdr.ipv6.srcAddr : lpm;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            set_multicast_replication_list;
        }
        size = IPV6_XCAST_FORWARDING_SIZE;
    }

    action set_urpf_check_fail() {
        meta.hop_metadata.urpf_fail = 1;
    }

    action urpf_check_fail() {
        set_urpf_check_fail();
        drop();
    }
    
    table igmp_snooping {
        key = {
            hdr.ipv4.dstAddr : lpm;
            hdr.vlan_tag_[0].vid : exact;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            nop; /* FIX */
        }
        size = IGMP_SNOOPING_SIZE;
    }
    
    table urpf_v4 {
        key = {
            hdr.vlan_tag_[0].vid : exact;
            standard_metadata.ingress_port : exact;
            hdr.ipv4.srcAddr : exact;
        }
        actions = {
            urpf_check_fail;
            nop;
        }
        size = URPF_V4_SIZE;
    }

    table check_ucast_ipv4 {
        key = {
            hdr.ipv4.dstAddr : exact;
        }
        actions = {
            on_hit;
            on_miss;
        }
        size = CHECK_UCAST_IPV4_SIZE;
    }

    table urpf_v6 {
        key = {
            hdr.vlan_tag_[0].vid : exact;
            standard_metadata.ingress_port : exact;
            hdr.ipv6.srcAddr : exact;
        }
        actions = {
            urpf_check_fail;
            nop;
        }
        size = URPF_V6_SIZE;
    }

    action set_egress_port(bit<9> e_port) {
        standard_metadata.egress_spec = e_port;
    }

    action set_vrf(bit<12> vrf) {
        meta.hop_metadata.vrf = vrf;
    }

    table vrf {
        key = {
            hdr.vlan_tag_[0].vid : exact;
            hdr.ethernet.srcAddr : exact;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            set_vrf;
        }
        size = VRF_SIZE;
    }

    action action_drop(bit<8> drop_reason) {
        meta.hop_metadata.drop_reason = drop_reason;
        drop();
    }
    table acl {
       key = {
           //Because multiple lpm is not supported hdr.ipv4.srcAddr : lpm;
           hdr.ipv4.dstAddr : lpm;
           hdr.ethernet.srcAddr : exact;
           hdr.ethernet.dstAddr : exact;
       }
       actions = {
           action_drop;
       }
       size = ACL_SIZE;
    }

    action set_ethernet_addr(bit<48> smac, bit<48> dmac) {
        hdr.ethernet.srcAddr = smac;
        hdr.ethernet.dstAddr = dmac;
    }
    table next_hop {
        key = {
            meta.hop_metadata.next_hop_index : exact;
        }
        actions = {
            set_ethernet_addr;
        }
        size = NEXT_HOP_SIZE;
    }
    
    apply {
        vrf.apply();
        switch(check_ipv6.apply().action_run) {
            on_hit : {
                switch(ipv6_prefix.apply().action_run) {
                    set_ipv6_prefix_ucast : {
                        urpf_v6.apply();
                        ipv6_forwarding.apply();
                    }
                    set_ipv6_prefix_xcast : {
                        ipv6_xcast_forwarding.apply();
                    }
                }
            }
            on_miss : {
                 switch(check_ucast_ipv4.apply().action_run) {
                     on_hit : {
                         urpf_v4.apply();
                         ipv4_forwarding.apply();
                     }
                     on_miss : {
                         igmp_snooping.apply();
                         ipv4_xcast_forwarding.apply();
                     }
                 }
            } 
        } 

        acl.apply();
        next_hop.apply();
    }
}


control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control ingress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {

    table smac_vlan {
        key = {
            hdr.ethernet.srcAddr : exact;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            nop; /* FIX */
        }
        size = SMAC_VLAN_SIZE;
    }
    
    table routable {
        actions = {
            on_hit;
            on_miss;
        }
        key = {
            hdr.vlan_tag_[0].vid : exact;
            standard_metadata.ingress_port : exact;
            hdr.ethernet.dstAddr : exact;
            hdr.ethernet.etherType : exact;
        }
        size = ROUTABLE_SIZE;
    }

    action set_egress_port(bit<9> e_port) {
        standard_metadata.egress_spec = e_port;
    }

    table dmac_vlan {
        key = {
            hdr.ethernet.dstAddr : exact;
            hdr.vlan_tag_[0].vid : exact;
            standard_metadata.ingress_port : exact;
        }
        actions = {
            set_egress_port;
        }
        size = DMAC_VLAN_SIZE;
    }
    @name(".process_ip") process_ip() process_ip_0;

    action set_pkt() {
        @atomic{
            bit<32> count_tmp;
            count.read(count_tmp, 0);
            if (count_tmp == N - 1) {
                meta.sample = 1;
                count_tmp = 0;
            } else {
                meta.sample = 0;
                count_tmp = count_tmp + 1;
            }
            count.write(0, count_tmp);
        }
    }

    table sample {
        key = {
        }
        actions = {
            set_pkt;
        }
    } 

    apply {
        smac_vlan.apply();
        switch(routable.apply().action_run) {
            on_hit : {
                process_ip_0.apply(hdr, meta, standard_metadata);
            }
        }
        dmac_vlan.apply();
        sample.apply();
    }
}

control egress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {
    }
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
ingress(),
egress(),
MyComputeChecksum(),
MyDeparser()
) main;
