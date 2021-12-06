get_structs(){
  grep '^struct ' *.h *.c |cut -d' ' -f2|sort -u
}





mod=libsco1
desc="$(cat <<-EOF
   $(ansi --blue --bg-black --italic "C Code Imported by other languages")
      - libcso1.c
                    libcso1_INT_TEST:           (int + int) -> int
                    libcso1_TEST_SIGNAL:        (int) -> void 
      - libcso1.h:

        $(while read -r s; do
          echo; grep "^struct ${s} {$" *.h *.c -A 999|grep '};$' -B 999
        done < <(get_structs)|while read -r l; do 
          echo -e "       $(ansi --yellow --bg-black --italic "$l")"
        done)
        
)
EOF
)"

msg="$(ansi --cyan --bg-black --bold --underline "$mod")- $desc"
>&2 echo -e "$msg"
