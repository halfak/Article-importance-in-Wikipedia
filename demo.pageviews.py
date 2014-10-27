from io import StringIO

from importance.sum_pageviews import (group_page_hours, read_hour_file,
                                      sequence_hour_files)

f1 = StringIO("""en ! 4 218877
en !! 3 46992
en !!! 4 67636
en !!!Fuck_You!!! 3 38085
en !!!Fuck_You!!!_And_Then_Some 1 12704
en !!!Fuck_You!!!_and_Then_Some 3 38073
en !!!_(Chk_Chk_Chk) 1 16989
en !!!_(album) 4 46212
en !!!_(band) 2 33972
en !!Destroy-Oh-Boy!! 2 55193""")
f2 = StringIO("""1644170:en !! 1 9002
en !!! 8 136126
en !!!Fuck_You!!! 3 25420
en !!!Fuck_You!!!_And_Then_Some 1 12713
en !!!Fuck_You!!!_and_Then_Some 1 12691
en !!!_(Chk_Chk_Chk) 1 16990
en !!!_(album) 1 11561
en !!!_(band) 1 16986
en !!Fuck_you!! 1 12701
en !!_(disambiguation) 1 9065""")
f3 = StringIO("""1447809:en ! 4 218877
en !! 3 46992
en !!! 4 67636
en !!!Fuck_You!!! 3 38085
en !!!Fuck_You!!!_And_Then_Some 1 12704
en !!!Fuck_You!!!_and_Then_Some 3 38073
en !!!_(Chk_Chk_Chk) 1 16989
en !!!_(album) 4 46212
en !!!_(band) 2 33972
en !!Destroy-Oh-Boy!! 2 55193""")

sequenced_hours = sequence_hour_files(
        [read_hour_file(f, ['en']) for f in [f1,f2,f3]])

for page_name, hours in group_page_hours(sequenced_hours):
    
    print("{0} {1}".format(page_name, list(hours)))
