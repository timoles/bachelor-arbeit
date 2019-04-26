# Transport which uses Malleable Extension

| Pro  | Con  |
|---|---|
| LUA Library is external dependency | Need to rewrite/change existing HTTP transport |
| Easy LUA script setting (directly build for it)  | Harded to do for initial transport (what is loaded first)  |
| Extended functionality easily implementable  |  |
| more logical from developer (system architecture) and user view || 

# Pure transport

| Pro  | Con  |
|---|---|
| Distinct isolation malleable/normal | Need to rewrite transport add/change functionality in client and server in order to add malleable script|
| Can use already implemented transport fallback | Dynamic script setting not working|
| Everything handled through transport interface (intuitive) | LUA library is always sent|