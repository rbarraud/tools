/*  KiwixComponent - XP-COM component for Kiwix, offline reader of Wikipedia
    Copyright (C) 2007, Fabien Coulon for LinterWeb (France)

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
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA */

#ifndef ENGINE_H_
#define ENGINE_H_

#include <stdio.h>
#include "index.h"

class engine {

public:
  void load( const char *root );
  listElements *search( const char *query );
  const char *getArticleName( listElements *res, int pos );
  const char *getArticleTitle( listElements *res, int pos );
  const char *getVocSpe( int pos );
  void wordCompletion( const char *word, char *buf, int maxlen );
  int  getScore( listElements *res, int pos );
  void debugWords();
  int  bValid;

protected:
  wordMap wm;
  wordIndex wi;
  articleMap am;
  articleIndex ai;
  listElements *vocSpe;
};



#endif
