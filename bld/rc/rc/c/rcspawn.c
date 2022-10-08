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
* Description:  RCSpawn() and RCSuicide() routines
*
****************************************************************************/


#include <stdlib.h>
#include "rcspawn.h"


static  jmp_buf *RCSpawnStack = jmpbuf_RCFatalError;


int     RCSpawn( void (*fn)( void ) )
/***********************************/
{
    jmp_buf     *save_env;
    jmp_buf     env;
    int         status;

    save_env = RCSpawnStack;
    RCSpawnStack = env;
    status = setjmp( env );
    if( status == 0 ) {
        (*fn)();
    }
    RCSpawnStack = save_env;
    return( status );
}

void    RCSuicide( int rc )
/*************************/
{
    longjmp( *RCSpawnStack, rc );
}
