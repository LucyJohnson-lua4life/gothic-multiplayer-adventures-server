- Different modules currently use the callback HasItem -> which requires an id to check in which context we want to check an item.
The ID's that are scattered across all modules should be centralized into one place, so that one can see which ID's are already in use.
- Right now the codebase is relatively small and easy to reason about. However before adding any mayor features, I would prefer to add 
test cases for the core modules of this project. Since im heavily relying on the GMP-API I need some mocking framework to mock the GMP calls in my test cases
- Integration tests of the DAO's would be nice
- GMP Function calls that deal with G2 item names are relatively fragile. If for example the item name does not exist, the code stops further execution, therefore
results in very unexpected behaviour. A solution for that should be found. 