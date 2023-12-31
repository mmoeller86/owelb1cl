/****************************************************************************
*
*                            Open Watcom Project
*
* Copyright (c) 2002-2023 The Open Watcom Contributors. All Rights Reserved.
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
* Description:  File I/O EOL output routines
*
****************************************************************************/


#include "ftnstd.h"
#include "posio.h"
#include "poscc.h"


#define FF_SEQ_LEN      sizeof( FFSeq );
#define SPC_SEQ_LEN     sizeof( SpcSeq );

static char     FFSeq[] = {
    CHAR_LF, CHAR_FF    // for form feeds
};

static char     SpcSeq[] = {
    CHAR_LF,            // for single spacing
    CHAR_CR, CHAR_LF,   // for double spacing
    CHAR_CR, CHAR_LF    // for triple spacing
};

static  bool    __lf_with_ff = false;

void    __LineFeedWithFormFeed( void )
//====================================
{
    __lf_with_ff = true;
}


int     FSetCC( b_file *io, char asa, const char **cc )
//=====================================================
// Output ASA carriage control character to a file.
{
    uint        cc_len;

    cc_len = 0;
    if( asa == '1' ) {
        *cc = FFSeq;
        cc_len = FF_SEQ_LEN;
        if( !__lf_with_ff ) {
            (*cc)++;
            --cc_len;
        }
    } else if( asa != '+' ) {
        *cc = SpcSeq;
        cc_len = SPC_SEQ_LEN;
        if( io->attrs & CC_NOLF ) {
            (*cc)++;
            cc_len--;
        }
        if( asa != '-' ) {
            cc_len -= 2;
            if( asa != '0' ) {
                cc_len -= 2;
            }
        }
    }
    io->attrs |= CC_NOLF;
    return( cc_len );
}
