/*
* test.c
* Example of a C program that interfaces with Lua.
* Based on Lua 5.0 code by Pedro Martelletto in November, 2003.
* Updated to Lua 5.1. David Manura, January 2007.
*/

#include "include\lua.h"
#include "include\lauxlib.h"
//#include "include\lua.hpp"
#include "include\luaconf.h"
#include "include\lualib.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#pragma comment(lib, "liblua53.a")



void bail(lua_State *L, char *msg){
	fprintf(stderr, "\nFATAL ERROR:\n  %s: %s\n\n",
		msg, lua_tostring(L, -1));
	exit(1);
}

int main(void)
{
	lua_State *L;

	L = luaL_newstate();                        /* Create Lua state variable */
	luaL_openlibs(L);                           /* Load Lua libraries */

	if (luaL_loadfile(L, "testFunction.lua")) /* Load but don't run the Lua script */
		bail(L, "luaL_loadfile() failed");      /* Error out if file can't be read */

	if (lua_pcall(L, 0, 0, 0))                  /* PRIMING RUN. FORGET THIS AND YOU'RE TOAST */
		bail(L, "lua_pcall() failed");          /* Error out if Lua file has an error */
	
	lua_getglobal(L, "encrypt");
	lua_pushstring(L, "evilMeterpreterData");
	if (lua_pcall(L, 1, 1, 0))
		bail(L, "lua_pcall() failed");
	const char *encryptedOut = lua_tostring(L, -1);
	printf("Sending out: %s\n", encryptedOut);

	lua_pop(L, 1);  /* Take the returned value out of the stack */ // Need to check if this is necessarry
	lua_getglobal(L, "decrypt"); /* Put decrypt function on the stack */
	lua_pushstring(L, encryptedOut); /* Push the string to decrypt */
	if (lua_pcall(L, 1, 1, 0)) /* call decrypt with the string */
		bail(L, "lua_pcall() failed");
	const char *decryptedIn = lua_tostring(L, -1); /* get the string back, carefull no Typesafety implemented!*/
	printf("Recieved Payload: %s\n", decryptedIn);
	
	lua_close(L); /* Clean up, free the Lua state var */
	printf("Closed lua...\n");
	return 0;
}