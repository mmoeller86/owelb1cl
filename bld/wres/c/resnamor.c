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


#include <string.h>
#include "layer0.h"
#include "resnamor.h"
#include "reserr.h"
#include "wresrtns.h"

ResNameOrOrdinal *ResStrToNameOrOrdinal( const char *string )
/***********************************************************/
{
    ResNameOrOrdinal    *newname;
    size_t              stringlen;

    if( string == NULL || *(unsigned char *)string == 0xff ) {
        /* the first character of a ResNameOrOrdinal can't be 0xff */
        /* since this indicated that it is an ordinal, not a name */
        WRES_ERROR( WRS_BAD_PARAMETER );
        return( NULL );
    }

    stringlen = strlen( string );

    newname = WRESALLOC( sizeof( ResNameOrOrdinal ) + stringlen );
    if( newname != NULL ) {
        /* +1 so we get the '\0' as well */
        memcpy( newname->name, string, stringlen + 1 );
    } else {
        WRES_ERROR( WRS_MALLOC_FAILED );
    }

    return( newname );
}

ResNameOrOrdinal *ResNumToNameOrOrdinal( uint_16 num )
/****************************************************/
{
    ResNameOrOrdinal    *newname;

    newname = WRESALLOC( sizeof( ResNameOrOrdinal ) );
    if( newname != NULL ) {
        newname->ord.fFlag = 0xff;
        newname->ord.wOrdinalID = num;
    }

    return( newname );
}
