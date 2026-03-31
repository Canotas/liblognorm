/**
 * @file helpers.h
 * @brief Implementation of the parse dag object.
 * @class ln_pdag pdag.h
 *//*
 * Copyright 2015 by Rainer Gerhards and Adiscon GmbH.
 *
 * Released under ASL 2.0.
 */
#ifndef LIBLOGNORM_HELPERS_H
#define LIBLOGNORM_HELPERS_H

#include <ctype.h>

static inline int myisdigit(char c)
{
	return (c >= '0' && c <= '9');
}

static inline int myisspace(const char c) {
	return isspace((unsigned char)c);
}
static inline int myisalnum(const char c) {
	return isalnum((unsigned char)c);
}

#endif
