# Remove empty tiers
#
# Written by Rolando Muñoz A. (14 Sep 2017)
#
# This script is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# A copy of the GNU General Public License is available at
# <http://www.gnu.org/licenses/1>.
#
form Remove empty tiers
  natural TextGrid_ID
endform

# Finde candidate tiers to be removed
selectObject: textGrid_ID
number_of_tiers = Get number of tiers
tier_counter = 0
for tier to number_of_tiers
  is_interval = Is interval tier: tier
  if is_interval
    n = Count intervals where: tier, "matches (regex)", ".+"
  else
    n = Count points where: tier, "matches (regex)", ".+"
  endif

  if !n
    tier_counter +=1
    tier[tier_counter] = tier
  endif
endfor

# If all tiers are removable, do nothing
if tier_counter = number_of_tiers
  exitScript()
endif

# Remove the tiers listed before
remove_counter = 0
for tier to tier_counter
    Remove tier: tier[tier] - remove_counter
    remove_counter +=1
endfor