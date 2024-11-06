#!/usr/bin/env python3

import sys
import datetime

print(datetime.datetime.fromisoformat(sys.argv[1]).timestamp())
