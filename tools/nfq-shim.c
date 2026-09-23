/*
 * nfqverdict-shim: translate nfq_set_verdict2_extra() calls made by
 * dpiclass/geoip into plain nfq_set_verdict2().
 *
 * The DumaOS binaries are linked against netduma's custom
 * libnetfilter_queue which carries an extra parameter
 *
 *   nfq_set_verdict2_extra(qh, id, verdict, extra_type, mark, data_len, data)
 *
 * and sends "extra" attributes in the verdict netlink message that the
 * stock Broadcom 4.1.52 kernel does not understand, so every verdict is
 * rejected (packets pile up in the nfqueue, e.g. all DNS is stuck).
 *
 * dpiclass also maps its ACCEPT verdict to the value 4 (a netduma kernel
 * extension); on a stock kernel 4 is NF_REPEAT, so the packet is requeued
 * forever. Map it back to NF_ACCEPT.
 *
 * Loaded via LD_PRELOAD before libnetfilter_queue, this shim forwards the
 * call to the plain verdict2 API which the kernel does support, dropping
 * the extra attribute (only used for mark, which verdict2 sets anyway).
 */
#include <stdint.h>
#include <stdio.h>
#include <errno.h>

struct nfq_q_handle;

extern int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
                            uint32_t verdict, uint32_t mark,
                            uint32_t data_len, const unsigned char *data);

int nfq_set_verdict2_extra(struct nfq_q_handle *qh, uint32_t id,
                           uint32_t verdict, uint32_t extra_type,
                           uint32_t mark, uint32_t data_len,
                           const unsigned char *data)
{
    static int e = 0;
    int r;
    if (verdict == 4)
        verdict = 1; /* NF_ACCEPT on a stock kernel */
    r = nfq_set_verdict2(qh, id, verdict, mark, data_len, data);
    if (r < 0 && e++ < 10)
        fprintf(stderr, "nfq-shim: verdict2 id=%u verdict=%u extra=%u mark=%u len=%u ret=%d errno=%d\n",
                id, verdict, extra_type, mark, data_len, r, errno);
    return r;
}
