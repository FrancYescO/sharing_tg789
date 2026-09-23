/*
 * nfqverdict-shim: translate nfq_set_verdict2_extra() calls made by
 * dpiclass/geoip into plain nfq_set_verdict2().
 *
 * The DumaOS binaries are linked against a recent libnetfilter_queue that
 * sends "extra" attributes (HW timestamp/clock) inside the verdict message.
 * Broadcom's 4.1.52 kernel on the TG789vac v2 does not understand those
 * attributes and rejects the verdict, so queued packets (router-originated
 * DNS in particular) never leave the nfqueue and DNS/cloud services hang.
 *
 * Loaded via LD_PRELOAD before libnetfilter_queue, this shim forwards the
 * call to the plain verdict2 API which the old kernel does support.
 */
#include <stdint.h>
#include <stdio.h>
#include <errno.h>

struct nfq_q_handle;

extern int nfq_set_verdict2(struct nfq_q_handle *qh, uint32_t id,
                            uint32_t verdict, uint32_t mark,
                            uint32_t data_len, const unsigned char *data);

int nfq_set_verdict2_extra(struct nfq_q_handle *qh, uint32_t id,
                           uint32_t verdict, uint32_t mark,
                           uint32_t data_len, const unsigned char *data)
{
    static int n = 0, e = 0;
    int r = nfq_set_verdict2(qh, id, verdict, mark, data_len, data);
    if (r < 0 && e++ < 10)
        fprintf(stderr, "nfq-shim: verdict2 id=%u verdict=%u len=%u ret=%d errno=%d\n",
                id, verdict, data_len, r, errno);
    if ((++n % 500) == 1)
        fprintf(stderr, "nfq-shim: verdict2_extra calls=%d\n", n);
    return r;
}
