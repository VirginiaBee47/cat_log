import csv
import argparse
import datetime

cat_aliasing = {'cleopatra': ['c', 'cleo', 'cleopatra'],
                'amumu': ['m', 'mumu', 'amumu']}

attribute_aliasing = {'weight': ['w', 'weight', 'm', 'mass'],
                      'injury': ['injury', 'inj']}

class ArgHolder:
    def __init__(self):
        self.cat = None
        self.attribute = None
        self.value = None
        self.date = None

def create_data_dict(args):
    # Put all of the data into the dictionary first
    data_dict = {'date': datetime.date.today() if args.date is None else datetime.datetime.strptime(args.date, "%d%m%Y").date(),
                 'cat': args.cat,
                 'attribute': args.attribute,
                 'value': args.value}

    # Then parse through to get it in the right format
    data_dict['date'] = data_dict['date'].strftime("%m/%d/%Y")

    for name, aliases in cat_aliasing.items():
        if args.cat.casefold() in aliases:
            data_dict['cat'] = name

    for name, aliases in cat_aliasing.items():
        if args.attribute.casefold() in aliases:
            data_dict['attribute'] = name

    if args.value == -99:
        data_dict['value'] = None
    return data_dict

def append_dict_to_csv(args, file_path='./cat_health.csv', fieldnames=['date', 'cat', 'attribute', 'value']):
    # Appends a dictionary as a row to a CSV file.
    with open(file_path, mode='a', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        # If the file is empty, write the header
        if file.tell() == 0:
            writer.writeheader()

        data_dict = create_data_dict(args)
        writer.writerow(data_dict)

def main():
    parser = argparse.ArgumentParser(prog='cat_log',
                                     description="Process some integers.")
    parser.add_argument("cat",
                        metavar="cat_name",
                        type=str,
                        help="The name of the cat for the data record.")
    parser.add_argument("attribute",
                        metavar="cat_attribute",
                        type=str,
                        help="The attribute of the cat for the data record.")
    parser.add_argument("value",
                        metavar="data_value",
                        type=float,
                        help="The value of the measurement taken (e.g. the weight (in grams) of the cat)")
    parser.add_argument("--date",
                        metavar="measurement_date",
                        type=str,
                        help="The date that the measurement was taken. In the format \"%d%m%Y\".")

    runtime_args = ArgHolder()
    parser.parse_args(namespace=runtime_args)

    append_dict_to_csv(runtime_args)

if __name__ == '__main__':
    main()