/*
 * fuzz_normalize.c - libFuzzer harness for ln_normalize
 *
 * Targets the ln_normalize() API with all major parser types loaded
 * via an inline rulebase string. This exercises CEF, checkpoint-lea,
 * name-value-list, quoted-string, op-quoted-string, and other parsers
 * that received recent escape-handling changes.
 *
 * Build:
 *   clang -fsanitize=fuzzer,address -g -O1 \
 *     -I../src \
 *     fuzz_normalize.c \
 *     -L../src/.libs -llognorm -lestr -ljson-c \
 *     -o fuzz_normalize
 *
 * Run:
 *   ./fuzz_normalize corpus/
 */

#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include "liblognorm.h"

/* A rulebase covering the major parser types that need fuzz coverage.
 * Using v2 rulebase format (JSON-based) loaded via ln_loadSamplesFromString.
 */
static const char *RULEBASE =
    "version=2\n"
    "rule=:%cef:cef%\n"
    "rule=:action: %action:word%; src: %src:ipv4%; dst: %dst:ipv4%;\n"
    "rule=:%nvl:name-value-list%\n"
    "rule=:%qs:quoted-string%\n"
    "rule=:%oqs:op-quoted-string%\n"
    "rule=:%num:number% %rest:rest%\n"
    "rule=:%ip:ipv4%\n"
    "rule=:%ip6:ipv6%\n"
    "rule=:%date:date-rfc3164% %rest:rest%\n"
    "rule=:%date5424:date-rfc5424% %rest:rest%\n"
    "rule=:%mac:mac48%\n"
    "rule=:user=%user:word% status=%status:word% code=%code:number%\n"
    "rule=:%ts:time-24hr% %rest:rest%\n"
    "rule=:%ts12:time-12hr% %rest:rest%\n"
    "rule=:%dur:duration% %rest:rest%\n"
    "rule=:%hex:hexnumber%\n"
    "rule=:%alpha:alpha%\n"
    "rule=:%ws:whitespace%%rest:rest%\n"
    "rule=:%checkpoint:checkpoint-lea%\n";

/* Shared library context - initialize once */
static ln_ctx g_ctx = NULL;

/* Called once before fuzzing starts */
static void init_ctx(void)
{
    g_ctx = ln_initCtx();
    if (g_ctx == NULL)
        abort();

    /* Load rulebase; ignore errors (some rule types need extra config) */
    ln_loadSamplesFromString(g_ctx, RULEBASE);
}

/*
 * libFuzzer entry point.
 *
 * Treats the fuzz input as a log message string and passes it directly
 * to ln_normalize. All parser code paths are exercised depending on
 * which rule matches the input.
 */
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    /* Initialize context on first call */
    if (g_ctx == NULL)
        init_ctx();

    /* ln_normalize operates on byte-counted strings; NUL bytes are allowed */
    struct json_object *json = NULL;
    ln_normalize(g_ctx, (const char *)data, size, &json);

    if (json != NULL)
        json_object_put(json);

    return 0;
}
