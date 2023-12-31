/****************************************************************************
*
*                            Open Watcom Project
*
* Copyright (c) 2002-2022 The Open Watcom Contributors. All Rights Reserved.
*    Portions Copyright (c) 1983-2002 Sybase, Inc. All Rights Reserved.
*
*  ========================================================================
*
*    This file contains Original Code and/or Modifications of Original
*    Code as defined in and that are subject to the Sybase Open Watcom
*    Public License version 1.0 (the 'License'). You may not use this file
*    except in compliance with the License. BY USING THIS FILE YOU AGREE TO
*    ALL TERMS AND CONDITIONS OF THE LICENSE. A copy of the License is
*    provided with the Original Code and Modifications, and is also
*    available at www.sybase.com/developer/opensource.
*
*    The Original Code and all software distributed under the License are
*    distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
*    EXPRESS OR IMPLIED, AND SYBASE AND ALL CONTRIBUTORS HEREBY DISCLAIM
*    ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
*    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR
*    NON-INFRINGEMENT. Please see the License for the specific language
*    governing rights and limitations under the License.
*
*  ========================================================================
*
* Description:  WHEN YOU FIGURE OUT WHAT THIS FILE DOES, PLEASE
*               DESCRIBE IT HERE!
*
****************************************************************************/


#include <stdio.h>
#include <string.h>
#include "madimp.h"
#include "madaxp.h"
#include "dis.h"

enum {
    #define regpick(id,type,reg_set)    IDX_##id,
    #define regpicku(u,id,type,reg_set) IDX_##id,
    #define palpick(pal,id)             IDX_##pal##_##id,
    #include "axpregs.h"
    #undef regpick
    #undef regpicku
    #undef palpick
    IDX_LAST_ONE
};

enum toggle_states {
    /* cpu register display toggles */
    CT_HEX              = 0x01,
    CT_EXTENDED         = 0x02,
    CT_SYMBOLIC_NAMES   = 0x04,

    /* fpu register display toggles */
    FT_HEX              = 0x01,
    FT_G_FLOAT          = 0x02,

    /* disassembler toggles */
    DT_PSEUDO_OPS       = 0x01,
    DT_UPPER            = 0x02
};

enum {
    CPU_REG_SET,
    FPU_REG_SET,
    NUM_REG_SET
};

struct imp_mad_state_data {
    unsigned    reg_state[NUM_REG_SET];
    unsigned    disasm_state;
};

typedef struct axp_reg_info     axp_reg_info;
struct axp_reg_info {
    mad_reg_info        info;
    unsigned            pal             : 7;
    unsigned            reg_set         : 1;
    unsigned            sublist_code    : 8;
};

struct mad_disasm_data {
    address             addr;
    mad_radix           radix;
    dis_dec_ins         ins;
};

struct mad_trace_data {
    addr_off            ra;
};

struct mad_call_up_data {
    addr_off            sp;
    addr_off            fp;
    addr_off            ra;
};

typedef struct mad_type_data {
    mad_string          name;
    unsigned            hex     : 1;
    union {
        const mad_type_info_basic       *b;
        const mad_type_info             *mti;
    }                   u;
} mad_type_data;

extern imp_mad_state_data       *MADState;

extern const mad_type_handle    RefTrans[];
extern const axp_reg_info       RegList[];
extern const unsigned_16        RegTrans[];
extern const mad_type_data      TypeArray[];

#define TRANS_REF(r)            RefTrans[(r) - DRT_AXP_FIRST]
#define TRANS_REG(mr,r) ((axpreg *)((unsigned_8*)(mr) + RegTrans[(r) - DR_AXP_FIRST]))

extern mad_status               DisasmInit( void );
extern void                     DisasmFini( void );
extern mad_disasm_control       DisasmControl( mad_disasm_data *, const mad_registers * );
extern mad_status               DisasmOne( mad_disasm_data *dd, address *a, int adj );
extern mad_status               GetPData( addr_off, axp_pdata_struct *axp_pdata );
extern int                      VariableFrame( addr_off );

extern mad_status               RegInit( void );
extern void                     RegFini( void );

#define NUM_ELTS( name ) (sizeof( name ) / sizeof( name[0] ) )

#define INS_MOV_SP_FP   0x47fe040f
