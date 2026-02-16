
| Memory Region              | Direction | Contents                                                     |
| -------------------------- | --------- | ------------------------------------------------------------ |
| Stack (High Address)       | ↓ ↑       | `function():`<br>`- stack_var`; <br>`main():`<br>`- local_var` |
| Free Memory                | ↕         | (Empty space)                                                |
| Heap                       | ↑         | `- heap_var`                                                 |
| Data Segment               | Static    | `- global_initialized`                                       |
| BSS Segment                | Static    | `- global_uninitialized`                                     |
| Text Segment (Low Address) | Static    | `- program code`<br>`- main()`<br>`- function()`             |
