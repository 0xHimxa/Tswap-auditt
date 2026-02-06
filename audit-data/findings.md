### [H-1]
**Description:** 

**Impact:** 

**Proof of Concept:**

**Recommended Mitigation:** 












## Informationals


### [I-1] `PoolFactory__PoolDoesNotExist` is not used and should be removed`

```diff
-   error PoolFactory__PoolDoesNotExist(address tokenAddress);

```

### [I-2] Lacking zero address checks

```diff
 constructor(address wethToken) {
+    if(wethToken == address(0)){
        revert;
    }
        i_wethToken = wethToken;
    }

```


### [I-3] `PoolFactory::createPool` should use `.symbol()` instead of `.name()`

```diff
-        string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).name());

+        string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).symbol());


```
