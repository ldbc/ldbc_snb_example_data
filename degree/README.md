## Degree Distributions

1. Generate `SF-X` using Datagen.
2. Use the data converter to concatenate the CSV files.
3. Run `./run.sh <scale-factor> <node>`, which create, loads, and transforms the raw schema, then compute the degree for the desired `node type` and produces graphics in `graphics/`. Examples,
```
# Degree distribution of Person nodes at scale factor 1
./run.sh 1 person

# Degree distribution of all node types at scale factor 10
./run.sh 10 all
```

### TODO
- [ ] Tag 
- [ ] TagClass
- [ ] Place
- [ ] Organisation 
- [ ] Don't load all data if, for example, only person requested