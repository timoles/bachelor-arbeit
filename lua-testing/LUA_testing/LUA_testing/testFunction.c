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



// metatable method for handling "array[index]"
static int array_index(lua_State* L) {
	int** parray = luaL_checkudata(L, 1, "array");
	int index = luaL_checkint(L, 2);
	lua_pushnumber(L, (*parray)[index - 1]);
	return 1;
}

// metatable method for handle "array[index] = value"
static int array_newindex(lua_State* L) {
	int** parray = luaL_checkudata(L, 1, "array");
	int index = luaL_checkint(L, 2);
	int value = luaL_checkint(L, 3);
	(*parray)[index - 1] = value;
	return 0;
}

// create a metatable for our array type
static void create_array_type(lua_State* L) {
	static const struct luaL_reg array[] = {
		{ "__index", array_index },
		{ "__newindex", array_newindex },
		NULL, NULL
	};
	luaL_newmetatable(L, "array");
	luaL_openlib(L, NULL, array, 0);
}

// expose an array to lua, by storing it in a userdata with the array metatable
static int expose_array(lua_State* L, int array[]) {
	int** parray = lua_newuserdata(L, sizeof(int**));
	*parray = array;
	luaL_getmetatable(L, "array");
	lua_setmetatable(L, -2);
	return 1;
}

// test data
int mydata[] = { 1, 2, 3, 4 };

// test routine which exposes our test array to Lua 
static int getarray(lua_State* L) {
	return expose_array(L, mydata);
}

int __declspec(dllexport) __cdecl luaopen_array(lua_State* L) {
	create_array_type(L);

	// make our test routine available to Lua
	lua_register(L, "array", getarray);
	return 0;
}

void bail(lua_State *L, char *msg){
	fprintf(stderr, "\nFATAL ERROR:\n  %s: %s\n\n",
		msg, lua_tostring(L, -1));
	exit(1);
}

int main(void)
{

	char * test1 = "h";
	char * test2 = "sldksjfglakjlkajsdflkasflkadjfaklsdfaksf";
	test1 = _strdup(test2);
	printf("%s\n", &test1);
	return 0;
	lua_State *L;

	L = luaL_newstate();                        /* Create Lua state variable */
	luaL_openlibs(L);                           /* Load Lua libraries */
	const char * luaFunction0 = "function encrypt0(s);s = '<html> viewstate0=\"' ..s ..  '\" </html>';return s;end;";
	luaL_loadstring(L, luaFunction0);
	//const char * luaFunction2 = "function print(s);io.write('printing....');";
	//luaL_loadstring(L, luaFunction2);
	if (lua_pcall(L, 0, 0, 0))
		bail(L, "lua_pcall() failed");
	lua_getglobal(L, "encrypt0");
	lua_pushstring(L, "evilMeterpreterData");
	if (lua_pcall(L, 1, 1, 0))
		bail(L, "lua_pcall() failed");
	const char *encryptedOut2 = lua_tostring(L, -1);
	printf("Sending out: %s\n", encryptedOut2);
	lua_close(L); /* Clean up, free the Lua state var */
	return 0;

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