#lang racket
(require net/url
         "encode.rkt")
(require net/base64)
(define 账号 "15381089274@GDPF.XY")
;(define 账号 "17774002784@GDPF.XY")
;(define 密码 password)
;(define 密码 (send (send txt get-editor) get-text))

;;original account and password
;==>void dial

;;路由器账号验证只需要验证
(define (Author rt-pass)
  (string-append
   "Cookie:Authorization=Basic%20"
   (bytes->string/utf-8 (base64-encode (string->bytes/utf-8 (string-append "admin:" rt-pass))))
   "%3D; ChgPwdSubTag="))

(define (dial acc pass rt-pass)
  (local (
          (define 拨号字段 (string->url (format "http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Connect=%C1%AC+%BD%D3 HTTP/1.1"  (encode acc) pass pass )))
          (define (拨号 账号 密码)
            (port->string (get-pure-port
                            拨号字段
                            `(
                              "Accept:text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                              "Accept-Encoding:gzip, deflate, sdch"
                              "Accept-Language:zh-CN,zh;q=0.8,en;q=0.6"
                              "Connection:keep-alive"
                              ;;"Cookie:Authorization=Basic%20YWRtaW46MTk5NjAxMDE%3D; ChgPwdSubTag="
                              ,(Author rt-pass)
                              "DNT:1"
                              "Host:192.168.1.1"
                              "Referer:http://192.168.1.1/userRpm/PPPoECfgRpm.htm"
                              "Upgrade-Insecure-Requests:1"
                              "User-Agent:Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.116 Safari/537.36"
                              )
                            #:redirections 0)))
          )
    (拨号 acc pass)))

(provide dial)
