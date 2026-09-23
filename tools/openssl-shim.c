/*
 * openssl-compat-shim: stubs for OpenSSL symbols the DumaOS openssl
 * binary expects but the Telstra libssl/libcrypto builds lack (no zlib,
 * no SRP, no NPN), which otherwise makes every "openssl" invocation die
 * with "undefined symbol: BIO_f_zlib" (exit 127) and break the DumaOS
 * cloud package verification (openssl dgst -sha256 -verify ...).
 *
 * Loaded via /etc/ld.so.preload. The cloud verify path (dgst) never
 * calls into these functions; TLS apps that would (s_client SRP/NPN,
 * TLS compression) are not used by DumaOS, and OpenSSL init handles the
 * NULL compression methods gracefully.
 */
#include <stddef.h>

void *BIO_f_zlib(void) { return NULL; }
void COMP_zlib_cleanup(void) {}

void *SRP_VBASE_new(const char *seed_key) { (void)seed_key; return NULL; }
int SRP_VBASE_init(void *vb, char *pass_file) { (void)vb; (void)pass_file; return 1; }
void *SRP_VBASE_get1_by_user(void *vb, char *username) { (void)vb; (void)username; return NULL; }
void SRP_user_pwd_free(void *u) { (void)u; }
int SRP_check_known_gN_param(void *g, void *N) { (void)g; (void)N; return 0; }
void *SRP_get_default_gN(const char *id) { (void)id; return NULL; }
int SRP_create_verifier(const char *user, const char *pass, void **salt,
                        void **v, void *N, void *g)
{ (void)user; (void)pass; (void)salt; (void)v; (void)N; (void)g; return 0; }

int SSL_CTX_set_srp_cb_arg(void *ctx, void *arg) { (void)ctx; (void)arg; return 0; }
int SSL_CTX_set_srp_strength(void *x, int y) { (void)x; (void)y; return 0; }
int SSL_CTX_set_srp_username(void *ctx, char *user) { (void)ctx; (void)user; return 0; }
int SSL_CTX_set_srp_username_callback(void *ctx, void *cb) { (void)ctx; (void)cb; return 0; }
int SSL_CTX_set_srp_verify_param_callback(void *ctx, void *cb) { (void)ctx; (void)cb; return 0; }
void *SSL_CTX_set_srp_client_pwd_callback(void *ctx, void *cb) { (void)ctx; (void)cb; return NULL; }
int SSL_set_srp_server_param(void *s, void *N, void *g, void *salt, void *v, void *u)
{ (void)s; (void)N; (void)g; (void)salt; (void)v; (void)u; return -1; }
void *SSL_get_srp_N(void *s) { (void)s; return NULL; }
void *SSL_get_srp_g(void *s) { (void)s; return NULL; }
char *SSL_get_srp_username(void *s) { (void)s; return NULL; }
void SSL_CTX_set_next_proto_select_cb(void *s, void *cb, void *arg) { (void)s; (void)cb; (void)arg; }
void SSL_CTX_set_next_protos_advertised_cb(void *s, void *cb, void *arg) { (void)s; (void)cb; (void)arg; }
int SSL_get0_next_proto_negotiated(const void *s, const unsigned char **data, unsigned *len)
{ (void)s; if (data) *data = NULL; if (len) *len = 0; return 0; }
