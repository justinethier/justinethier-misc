(import 
  (scheme base)
  (lib json)
  (scheme cyclone test))

(test-group 
  "constants"
  (test "1" (->json-string 1))
  (test "\"test\"" (->json-string "test"))
  (test "\"\\n\"" (->json-string #\newline))
  (test "true" (->json-string #t))
  (test "null" (->json-string '()))
; TODO:
;(->json "a / long string\r\n\\\t\a'\"\" DONE")
)

(test-group "lists"
  (test "[\"a\", \"b\"]" (->json-string '(a . b)))
  (test "[1, 2, 3, 4]" (->json-string '(1 2 3 . 4)))
  (test "[\"A\", \"B\"]" (->json-string '(#\A #\B)))
; TODO:
;(->json '(1 2 3 4)) (newline)
;(->json '((a . 1) (b . 2) (c . 3) (d . 4))) (newline)
;(->json '((a 1) (b 2) (c 3) (d 4 5 6))) (newline)
)

(test-group "vectors"
  (test "[1, 2, 3, 4]" (->json-string #(1 2 3 4)))
  (test "[1, 2, 3, 188]" (->json-string #u8(1 2 3 444)))
)

(test-exit)

