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
* Description:  WHEN YOU FIGURE OUT WHAT THIS FILE DOES, PLEASE
*               DESCRIBE IT HERE!
*
****************************************************************************/


#include <stdio.h>
#include <fcntl.h>
#include <io.h>
#include <errno.h>
#include <string.h>


int main( int argc, char * argv[] ) {
    int         numRead;
    uint_8      c;
    int         outfile;

    if( argc != 2 ) {
        printf( "usage:  hexit <outfile>\n\n" );
        return 0;
    }

    outfile = open( argv[1], O_WRONLY | O_BINARY | O_CREAT );

    if( outfile < 0 ) {
        printf( "%s: %s\n", argv[1], strerror( errno ) );
    }

    while( 1 ) {
        numRead = scanf( "%hx", &c );
        if( numRead < 0 ) break;

        write( outfile, &c, sizeof( uint_8 ) );
    };

    close( outfile );

    return 0;
}
