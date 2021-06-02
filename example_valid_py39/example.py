class Decorator:
    def dec(self, func):
        return func


buttons = [Decorator() for i in range(10)]


@buttons[0].dec
def good_code():
    pass
