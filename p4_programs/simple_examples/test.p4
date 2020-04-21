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
// #include "parser.p4"
#include "headers_16.p4"
//#include "actions_16.p4"
//#include "tables.p4"

struct headers {
    ipv4_t                                  ipv4;
    ipv6_t                                  ipv6;
    vlan_tag_t[2]                           vlan_tag_;
    ethernet_t                              ethernet; 
}

struct metadata {
    hop_metadata_t        hop_metadata;
}

action on_hit() {
}
action on_miss() {
}
action nop() {
}
action drop() {
}
/*
action set_vrf(bit<12> vrf) {
    hop_metadata.vrf = vrf;
}

action set_ipv6_prefix_ucast(bit<64> ipv6_prefix){
    modify_field(hop_metadata.ipv6_prefix, ipv6_prefix);
}

action set_ipv6_prefix_xcast(bit<64> ipv6_prefix){
    modify_field(hop_metadata.ipv6_prefix, ipv6_prefix);
}

action set_next_hop(bit<16> dst_index) {
    modify_field(hop_metadata.next_hop_index, dst_index);
}

action set_ethernet_addr(bit<48> smac, bit<48> dmac) {
    modify_field(ethernet.srcAddr, smac);
    modify_field(ethernet.dstAddr, dmac);
}

action set_multicast_replication_list(bit<16> mc_index) {
    modify_field(hop_metadata.mcast_grp, mc_index);
}

action set_urpf_check_fail() {
    modify_field(hop_metadata.urpf_fail, 1);
}

action urpf_check_fail() {
    set_urpf_check_fail();
    drop();
}

action set_egress_port(bit<9> e_port) {
    modify_field(standard_metadata.egress_spec, e_port);
}

action action_drop(bit<8> drop_reason) {
    modify_field(hop_metadata.drop_reason, drop_reason);
    drop();
}
*/

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
/*
    apply(vrf);
    apply(check_ipv6) {
        on_hit {
            apply(ipv6_prefix) {
                set_ipv6_prefix_ucast {
                    apply(urpf_v6);
                    apply(ipv6_forwarding);
                }
                set_ipv6_prefix_xcast {
                    apply(ipv6_xcast_forwarding);
                }
            }
        }
        on_miss {
            apply(check_ucast_ipv4) {
                on_hit {
                    apply(urpf_v4);
                    apply(ipv4_forwarding);
                }
                on_miss {
                    apply(igmp_snooping);
                    apply(ipv4_xcast_forwarding);
                }
            }
        }
    }*/
//    apply(acl); /* Perhaps right before routable */
//    apply(next_hop);

    action set_vrf(bit<12> vrf) {
        meta.hop_metadata.vrf = vrf;
    }

    table vrf {
        key = {
            // hdr.vlan_tag_[0] : exact;
            // hdr.vlan_tag_[0].vid : exact;
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
           hdr.ipv4.srcAddr : lpm;
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
        next_hop.apply();
        acl.apply();        
    }
}


control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control ingress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
/*
    apply(smac_vlan);
    apply(routable) {
        on_hit {
            process_ip();
        }
    }
    apply(dmac_vlan);
*/
    apply {
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
