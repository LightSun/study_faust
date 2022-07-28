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

#ifndef _doc_stringFAUST_H
#define _doc_stringFAUST_H

/**********************************************************************
        Historique :
        -----------
        17-11-2001 : initial implementation  (yo)
        2009-08-17 : adaptation for documentator (kb)
***********************************************************************/
#include <string>
#include <vector>
using namespace std;

string docT(char* c);
string docT(int n);
string docT(long n);
string docT(double n);

#endif
