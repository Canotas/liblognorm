/*
 * NOTE: This file is intentionally disabled and is NOT compiled or run
 * as part of the test suite.  The corresponding Makefile.am entries are
 * commented out (see the user_test_SOURCES / user_test_LDADD blocks).
 *
 * Before re-enabling this test you should either:
 *   a) Update it to work against the current public API (v2 pdag engine), or
 *   b) Remove this file entirely if the v1 API it exercises is no longer
 *      supported.
 *
 * Tracked in: https://github.com/rsyslog/liblognorm/issues/30
 */
#include "config.h"
#include <string.h>
#include "liblognorm.h"
#include "v1_liblognorm.h"

int main() {
	const char* str = "foo says hello!";
	json_object *obj, *from, *msg;
	obj = from = msg = NULL;
	ln_ctx ctx =  ln_initCtx();
	int ret = 1;

	ln_v1_loadSample(ctx, "rule=:%from:word% says %msg:word%");
	if (ln_v1_normalize(ctx, str, strlen(str), &obj) == 0) {

		json_object_object_get_ex(obj, "from", &from);
		json_object_object_get_ex(obj, "msg", &msg);

		ret = strcmp(json_object_get_string(from), "foo") ||
			strcmp(json_object_get_string(msg), "hello!");
	}

	if (obj != NULL) json_object_put(obj);
	ln_exitCtx(ctx);

	return ret;
}
