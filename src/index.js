import fs from "fs";
import specmd from "spec-md";

const html = specmd.html("spec/main.md");
fs.writeFileSync("out/index.html", html);
