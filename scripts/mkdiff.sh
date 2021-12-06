diff -Naur eval.c.orig eval.c > ../../../patches/010-eval-command-callback.patch
diff -Naur builtins/cd.def.orig builtins/cd.def > ../../../patches/011-builtins-cd.patch

#bat ../../../patches/010-eval-command-callback.patch
git add ../../../patches/*.patch
git commit ../../../patches/*.patch -m 'auto commit'
git push
