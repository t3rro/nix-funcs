{
  description = "pure functions";

  outputs = { ... }:
    let
      # input is a set of attrs and it is returned in array format
      # but deep copies all values.
      attrsToArr = attrs:
        let
          addAttr = attrName: result: result ++ [{ name = attrName; value = attrs.${attrName}; }];
          allAttrs = builtins.attrNames attrs;
        in
        builtins.foldl' addAttr [ ] allAttrs;
    in
    {
      # use lib keyword on outputs to expose nix functions
      lib = {
        inherit attrsToArr;
      };
    };
}
