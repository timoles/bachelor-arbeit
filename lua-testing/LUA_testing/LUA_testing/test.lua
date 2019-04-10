-- script.lua
-- Receives a table, returns the sum of its components.
base64=require("./ee5_base64")
print( base64.encode("This is a string") )
print( base64.decode("RHVkZSEgV2hlcmUgaXMgbXkgY2FyPz8/Cg==") )

io.write("The table the script received has:\n");
x = 0
for i = 1, #foo do
  print(i, foo[i])
  x = x + foo[i]
end
io.write("Returning data back to C\n");
x = 200;
return x