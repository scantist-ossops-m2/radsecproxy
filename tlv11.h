/* Copyright (c) 2008, UNINETT AS
 * Copyright (c) 2010, NORDUnet A/S */
/* See LICENSE for licensing information. */

struct tlv {
    uint8_t t;
    uint8_t l;
    uint8_t *v;
};

struct tlv *maketlv(uint8_t, uint8_t, void *);
struct tlv *copytlv(struct tlv *);
void freetlv(struct tlv *);
int eqtlv(struct tlv *, struct tlv *);
struct list *copytlvlist(struct list *);
void freetlvlist(struct list *);
void rmtlv(struct list *, uint8_t);
uint8_t *tlv2str(struct tlv *tlv);
struct tlv *resizetlv(struct tlv *, uint8_t);

/* Local Variables: */
/* c-file-style: "stroustrup" */
/* End: */
