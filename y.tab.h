/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    tINT = 258,
    tVOID = 259,
    tCONST = 260,
    tPO = 261,
    tPF = 262,
    tACO = 263,
    tACF = 264,
    tPOINTVIR = 265,
    tVIR = 266,
    tEGAL = 267,
    tPLUS = 268,
    tMOINS = 269,
    tFOIS = 270,
    tDIV = 271,
    tRETURN = 272,
    tPRINTF = 273,
    tSTRING = 274,
    tGUIL = 275,
    tIF = 276,
    tWHILE = 277,
    tERROR = 278,
    tID = 279,
    tINTVAL = 280
  };
#endif
/* Tokens.  */
#define tINT 258
#define tVOID 259
#define tCONST 260
#define tPO 261
#define tPF 262
#define tACO 263
#define tACF 264
#define tPOINTVIR 265
#define tVIR 266
#define tEGAL 267
#define tPLUS 268
#define tMOINS 269
#define tFOIS 270
#define tDIV 271
#define tRETURN 272
#define tPRINTF 273
#define tSTRING 274
#define tGUIL 275
#define tIF 276
#define tWHILE 277
#define tERROR 278
#define tID 279
#define tINTVAL 280

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 18 "source.yacc" /* yacc.c:1909  */

        int num;
        char type;
        char str[16];

#line 110 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
