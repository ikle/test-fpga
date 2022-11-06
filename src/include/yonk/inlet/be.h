/*
 * Big-Endian Input Stream helpers
 *
 * Copyright (c) 2011-2022 Alexei A. Smekalkine <ikle@ikle.ru>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

#ifndef YONK_INLET_BE_H
#define YONK_INLET_BE_H  1

#include <stdint.h>

#include <yonk/inlet.h>

static inline int inlet_get_be16 (struct inlet *o, uint16_t *y)
{
	unsigned char a, b;

	if (!inlet_get (o, &b) || !inlet_get (o, &a))
		return 0;

	*y = a | ((uint16_t) b << 8);
	return 1;
}

static inline int inlet_get_be32 (struct inlet *o, uint32_t *y)
{
	uint16_t a, b;

	if (!inlet_get_be16 (o, &b) || !inlet_get_be16 (o, &a))
		return 0;

	*y = a | ((uint32_t) b << 16);
	return 1;
}

static inline int inlet_get_be64 (struct inlet *o, uint64_t *y)
{
	uint32_t a, b;

	if (!inlet_get_be32 (o, &b) || !inlet_get_be32 (o, &a))
		return 0;

	*y = a | ((uint64_t) b << 32);
	return 1;
}

#endif  /* YONK_INLET_BE_H */
