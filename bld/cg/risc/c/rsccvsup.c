/****************************************************************************
*
*                            Open Watcom Project
*
* Copyright (c) 2002-2018 The Open Watcom Contributors. All Rights Reserved.
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


#include "_cgstd.h"
#include "coderep.h"
#include "procdef.h"
#include "model.h"
#include "zoiks.h"
#include "cgaux.h"
#include "cvdbg.h"
#include "owl.h"
#include "rscobj.h"
#include "dbsyms.h"
#include "cvsyms.h"
#include "objout.h"
#include "rsccvsup.h"


static  section_def         *CVSymMain;
static  owl_section_handle  owlCVSym; //.debug$s for non-comdats .text

void    CVDefSegs( void )
/***********************/
{
    if( _IsModel( CGSW_GEN_DBG_LOCALS ) ) {
        CVSyms = DbgSegDef( ".debug$S"  );
        CVSymMain = FindSection( CVSyms );
        owlCVSym = CVSymMain->owl_handle;
    }
    if( _IsModel( CGSW_GEN_DBG_TYPES ) ) {
        CVTypes = DbgSegDef( ".debug$T" );
    }
}

void  CVDefSymNormal( void )
/**************************/
{
    if( _IsModel( CGSW_GEN_DBG_LOCALS ) ) {
        CVSymMain->owl_handle = owlCVSym;
    }
}

void  CVDefSymComdat( owl_section_handle depof )
/**********************************************/
{
    if( _IsModel( CGSW_GEN_DBG_LOCALS ) ) {
        CVSymMain->owl_handle = DbgSectDefComdat( ".debug$S" );
        OWLComdatDep( CVSymMain->owl_handle, depof );
    }
}
