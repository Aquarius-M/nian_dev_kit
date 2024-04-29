import 'dart:convert';

const iconData =
    r'iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAAAAAXNSR0IArs4c6QAAD1tJREFUeF7tnV9y5DYOxtXZE/gYO7V3yLiq3zJ3SnynzFtXjX2HreQYc4KNN+wRHVmWiD8EJZD4/GiRFPkBP4KgJPZlwh8UgAK7ClygDRSAAvsKABB4BxQoKABA4B5QAIDAB6CATgFEEJ1uqBVEAQASxNAYpk4BAKLTDbWCKABAghgaw9QpAEB0uqFWEAUASBBDY5g6BQCITjfUCqIAAAliaAxTpwAA0emGWkEUACBBDI1h6hQAIDrdUCuIAgAkiKExTJ0CAESnG2oFUQCABDE0hqlTAIDodEOtIAoAkCCGxjB1CgAQnW6oFUQBABLE0BimTgEAotMNtYIoAECCGBrD1CkAQHS6oVYQBQBIEENjmDoFAIhON9QKogAACWJoDFOnAADR6YZaQRQYEpDr9fr5drs9B7EhhtlQgeEAuV6v36Zp+jxN0yMgaeg5QZoeCpAFHNl8gGTHkVOUnSeSVOLnuVj6X/pbR9+XRTPPkSaeYQDZgAOQrOCYofh1AUZNHHhKlW+32281jXivOwQgBTjCQ2IMxZ4/p4jzMiIs3QPCgCMsJAJtLCfyp5FA6RoQhQOEyEnmqJE2K878GwKUbgFRwBEiklyv15QTpDzDw1/3S68uAamAY2hInMGxBLTbaNIdIAZwDAmJoS5Lx15u9+YtYE1kAiAa1aR1GjjBEDmJkS4Jhrx1u/kWwsazEw403cKR/LObCGLkBFtMdg1J5bLqDoXmwR/zvl3D0Q0gQjjuiaEwUe0SEqaTbk0KajBSY8z7dg9HF4BI4bjdbo8CIy6dpytImE66CUfWSLrEFeiaXke526H3P9dLLC0c2SgKJ+oGkuv1+qpwvqpZnavn7XYj/SrnM94fKpIDURjBpEotHCNDwnXUlSGq4Bfck7zP6kFmFbQmzlZoxCUgVnCMCInyKTnptCVHE9yTdPattjgRpzUIe+27A8QajtEgEczkeeik01LOx1zOkfcp9J2sS/Wx1XVXgLSCYxRIBDO5JRz5A7SSD5IOzgC7KsoND0hrOEaAhOFk7/ykdunCvJ8FHKnfLne+XESQo+DoHRLmUscyelAvPpJOLbStuyhyOiBCAUmDcEMtc3ZcNneq8YT9JWd1jk4M2+xqovxQy8y+nPFxypwKCMMAyzGYiyd0utSX0yAR9vUIQHbvociVsp3NbcyBoFTmNECEBk/fPjfpq7QfZ0EiWV5ZaUVMYJuTRQUc2U9Pm4S2QGnidFxqz44gi5yEs1NzWiIpdDqT6JEGKwVEMdlsuYqrKHIqIAwjrAU0F0/gfOb3FkwkVLLcJFciAEmvxq+/F+F+yZjq7b0qf5rO7iKIYgY3ncV7gGOeRLiAmDqXMMJzeL/3j4o0VktEToeoMqdHkLMg6QWOgQB5g5ehvZs8xA0gRy63qBlsMauYzsjUbLV3XTCTm+UfCnuUhvehX8Smg+k4tLqneq4AURhF7MC9wSGMIKaOJQBTBAfDzmK71kBQqusOEIZ46sRdAEe6h6mz1RhQ0G/TPhsAUnpWUto5BCCUwwiNQwoqcLJl10wdjhpzYYnFTdJN+yu0wbr7xTyCsAdpT62W0nouI4h14q6EI3fD1OmkBpojatoS5ZyUaJrczrrlk9+XXV+e9r41JPIEeAo+LztZrgGxWG5VwuECEsauj4t+SuAHIBK1iLKUmKvqy+1E7tKE09tTIwnzVRM3SxNKUGo8iCCUgqvrUkjm6pyDzSQ9OQ0S7vi9OBYlKgChFFJc5zqJomlJlcMhES4TTfMQiTCSsgBEopagbDRIhHAkJd0DwhmTl0joPknfYicKJBxH2tDHfR7CsJ+bMXQJiGJ3SxCjREWbLbeUcNw772X23ZncOBsnzXQVWdfjqyaSATBmIklz2rLmxqyBYx6E22UWc2zmmmqN220EyQMWQpLPi+U8dJNoamZQpgOV+mbWF4kA3LJUcj6342YM3QMiWG69zaqCB29cu6dy1UYNAAdneeVqiTgEIAxIPiw5vEECON7mIjcJeurRMIAUIKGOpjl9uQU43gXq6kgsCftU2aEA2YCETFbPjiSjwzHbhP1TDd524IYDZAFJmok2f2tvPWucBUkQOLgnxpjkcVREkF4fEhCpCDNU3FfKJc2XPhhiJayFm7laiuxMOumUE8n7cO7GBEAWlj0qkoweOZTjcwfHcEm6ZGrfK9saEqXzLLvr0pFyB4XPpd7G5S33yB1DBNkgpRUk8624h6ttMWwKRxonN08rTT7Kg6q7gB6A7Fi+ESQ1Qc4cjsVnvOmUxPSALuVF7D8DMFwm5ksBAEjBHRxB0hKOLQXyb82na+tjQvM36pLke09lVw8FtzoJQIj50gEkR8PBjiCVBd3DgSSdaeETIQEcTBu1KoYIwlT2BEgAB9M2LYsBEIG6B0IyKhym4xKYTl0UgAilOwASUyc6oL9cBcn34rgNHVkOgCjUbuh0I8JhOiaFuaqqABClfA0gMXWkBv2TKpW2h9kvjEobP6o8AKlQ2tAJR4JjCDCyWwCQCkBSVQNIvMFR+v3A3Qd+I0QLPCishGGvesULiN7geOvPDH7pafn9WxuLd7kamcWkWUSQShm1b69aHPKw7Lq3SFYpq5vqAKTCFICjQrxOqgIQhaEqZ2u3yyqFFMNXASBCEwMOoWCdFwcgAgNWJOPpLogcAq29FAUgTEsADqZQgxUDIAyDAg6GSIMWASCEYSt2qrCsGgAaAFIwIuAYwMMrhwBANgQ0OIwACXmlY3qpDkBWlqjcxsWyyotnG/UDgCyErEzGAYeRU3pqZnhA5ojwQfP1S3aAw5Nb+unLUIAsYMinF1JnN+Xzn9JZT1TZktWQc/jxadOeDAGIQVJdI+qQcHz/9OV+yuLDH7+LTlusEdJj3a4BMVgW1dpkYDhe5yh8eYoMSZeAOABj2IT8R+TIcOT5Iy4kXQFy8lJqGW0CRI51cI0JSTeAOIkawSIHIOkCEMCxmyqZRLLtZdXePWNFEveAVL4PVZuEB19WARLXgAAOT5Ej5nLLLSDGy6r1z0G/zObmPCA0WcZk9/LyrpdsWbUD6k+Xx4f//s76qW3LUH5kWy4BMYKDfcLf6gyo5W8IAo49bwwARxq6O0Aq4WBDUZqF8isrloeiIXIcOe/b3csjIK+K4ZmAobgvqwrgYMnkspArQJRJuevfuhsKjuTCr9Pzw59fH116c4NOuQFEubQyzRGs9e0PjsvT9Pr683Qh3mwOBEnPgLj+xaIe4cgvJX7/9y/fAMmP6dIFIIroATgY4Y6/lfvx6Tgg6RcQLKsaw5GbByR+Igh35wpwHAQHIHESQQRrdexWHQwHIHEQQbj5x+12c5EvbfmoAPI9FzeJjDU5B8Ve1OXW6U7HfPZh4kCUE2iuR4AjciTxAAgn/xgVEJNxtYwc60kjWiTpAhDPy6vkQNfrlQP52te6gyNiJOkBEBNH0iyfuHWYy8RlcyZjOjJyRI0kpwLCWb97jx5zBElnRy1fky+x1T0ckSIJAOGGiUI5Duhz9YPhuL8s0fRcq9FzEu+AuH72kZkRAFI9Hv6yakk0INHOgwBEq9yqHjNRrwJEB0fuKCDRmNo7IKwlyd4J7sSB1MlZzb6n5ibq2pzq+3++fJ7+ev2mMfI/dQCJVL/uAeE+id8QhgUfV1AuINM0qd9ErosgiCRcW75bnGoqWdYhliZFJxY45VaXuwMkDQKQWHof3dapEWTeIi09ZNtcsxud0dslIICEdmrLEh4ASevqvR+v+QCIYMeI0skaEO7TdPUSazkgRBLKvDbXvQMyLZPainzjiCXWoYCQkeR1eiY/m72rgsS9hJIHQFL0KO3O3GdcYziSJl1HkGzUzUgyH+rGeogHSIqhpgdAnuYRcF7lyL85mAddOlrUDBAJvNpt3pIV30GyOvGwK0gaRzPNout0QOZEvZSHcMe1la+U2h0GkLfl1k/T89ZZuYCE60Ify40CyKazE9vAloBw84+qJ+l6M09TT5A8/PHVhV/eM7Qa0a3qVu5M7Tr6EYBIllfWeY9U/34gabtxINHNBSAVy6zilmnNQ0iuiMx3sHJzJlu83L5tlXMDyadfilHXSxTpGRAKDuobjeolljB6vNuyrnHy2roeIKGf4/iIIp4AobZ7s1+QJ7kzHdcCEG7uYb6tPD4kAOSDjRmOTSa5jDZMljuC+9zv12J7t3dIqDeUPSyz3ESQbOzCmp6c8QVOS7ZVcj7BfXIzVferBaH4DIVzUPW9gTYz+vdCLgJANiy343ykgwl2wsi2CDi4S8G3ZjxGj+UYz8xJSoBMDn7mzV0E2djRYjk0czeJ1dYeIAIIl01U3bNl9PAACQBRWHjhiKxtUeZ3IVWOqlhWuc099kxydCShchBEkAI8CRLOJ7FMxz0FjrMfDCrmpkOfuAMQjYUEdQ6CQ/ueWBWUAhnMix4VSYr3cfIzby5zEI7FmXCQ28Jb9zL4YrFbOLIerSEhowcA4WCwXYYJR6qcXpVnn15iAEa6pwpKvRrtaraEpJicpyE52MG6b263k7dNy8qdpLvj/n2iyMuqV+l7kfy399mvZCDDwNEqktwjx/9efyW/dgQgEr/7pyxzO1fXeF2t4eAQQ5I+8/3X5Wnrm5TUFv3+Vb5jm4eSGvP2GEHSS4jpj/OFoUYTTZ1h4RBDkiskWO5rlMsL67fXF/Ue/vz6qDFCizrdAZJFmPMQD6B0n5BzHYufk3Bb3CjnZGn1FssqhuKi6omgkG8VuxDIuBNtIfGztBoGkBMiSkgwlpy1gcQfHPcVovEE46K5RlElPBjvIPn05bdpejXKA33CMSwgS0PO28JpCzdv6XK3c/PJ7ynHMDsF3sUMYtQJ9pbt7v0uT9POSSxGXaxuZsgIwlFl7ycTAANHvfdl5KD4jRjr0YcFRO4GqEEpcAcl/f01fb5v7b5lupcfD2idR4ut8QEQyuq4HloBABLa/Bg8pQAAoRTC9dAKAJDQ5sfgKQUACKUQrodWAICENj8GTykAQCiFcD20AgAktPkxeEoBAEIphOuhFQAgoc2PwVMKABBKIVwPrQAACW1+DJ5SAIBQCuF6aAUASGjzY/CUAgCEUgjXQysAQEKbH4OnFAAglEK4HloBABLa/Bg8pQAAoRTC9dAKAJDQ5sfgKQUACKUQrodWAICENj8GTykAQCiFcD20AgAktPkxeEoBAEIphOuhFQAgoc2PwVMKABBKIVwPrQAACW1+DJ5SAIBQCuF6aAUASGjzY/CUAgCEUgjXQysAQEKbH4OnFPg/kyOvUCipX34AAAAASUVORK5CYII=';

final iconBytes = base64Decode(iconData);