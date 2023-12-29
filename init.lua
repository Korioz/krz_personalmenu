VERSION = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)

print(
    "^0======================================================================^7\n" ..
    "^0[^4Author^0]^7 :^0 ^0Korioz^7\n" ..
    ("^0[^3Version^0]^7 :^0 ^0%s^7\n"):format(VERSION) ..
    "^0[^2Download^0]^7 :^0 ^5https://github.com/korioz/krz_personalmenu/releases^7\n" ..
    "^0[^1Issues^0]^7 :^0 ^5https://github.com/korioz/krz_personalmenu/issues^7\n" ..
    "^0======================================================================^7"
)
