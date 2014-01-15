
```
----(input)
       |
      CLI ----(options)
       :         |
       | <-------|
       |
   Generator --(json)--> SchemaReader --(schema)--> SchemaParser
       :                                                 |
       | <------------------------------------------(ModelData)
       |
       |---(ModelData)---> Mapper
       :                     |
       :                     |-----> ObjCMapper -----(ObjCModel)-|
       :                     :   |                               |
       :                     :   |-> *Mapper --------(*Model)----|
       :                     :                                   |
       :                     | <---------------------------------|
       | <-----(Models)------|
       |
       |-------(Models)-------> Writer ---> (File System)
       :
       :
  ErrorHandler
```
