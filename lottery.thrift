namespace py lottery

service Lottery {
  list<map<string, set<string>>> result(1:string url)
}

