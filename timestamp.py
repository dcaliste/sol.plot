#!/usr/bin/env python3

import sys
import datetime

print(datetime.datetime.strptime(sys.argv[1], "%Y-%m-%d").timestamp())
