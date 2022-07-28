/************************************************************************
 ************************************************************************
    FAUST compiler
    Copyright (C) 2003-2018 GRAME, Centre National de Creation Musicale
    ---------------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 ************************************************************************
 ************************************************************************/

#ifndef _SIGTYPERULES_
#define _SIGTYPERULES_

#include "signals.hh"
#include "sigtype.hh"

extern bool gVectorSwitch;

/** \file sigtyperules.hh
 * API to the typing system of signals
 *
 * Two functions are provided :
 *
 * \li void typeAnnotation(Tree term)       : annotates a signal term and its subterms with type information
 * \li Type getCertifiedSigType(Tree term)  : return the type of a previously annotated signal term
 *
 * TypeAnnotation must be called first to annotate a signal or a list of signals, before being able to
 * call getCertifiedType on any subterms. GetCertifiedType will produce an error if a term was not
 * previously annotated.
 *
 **/

/**
 * Fully annotate every subtree of term with type information.
 * @param sig the signal term tree to annotate
 * @param causality when true check causality issues
 */
void typeAnnotation(Tree sig, bool causality);

/**
 *	Return the type of a previously annotated signal term
 */
::Type getCertifiedSigType(Tree term);

/**
 *	print annotation statistics
 */
void annotationStatistics();

/**
 * convert a constant signal into a double using its bounds (not very safe)
 * @param sig the signal to be converted
 * @return the mean of its biggest and smallest value
 */
double constSig2double(Tree sig);

#endif
