from mrjob.job import MRJob

class BudgetByLanguageCountry(MRJob):

    def mapper(self, _, line):
        parts = line.strip().split('|')
        if len(parts) == 5:
            title, year, language, country, budget = parts
            try:
                budget = int(budget)
                yield (language, country), budget
            except ValueError:
                pass

    def reducer(self, key, values):
        yield key, sum(values)

if __name__ == '__main__':
    BudgetByLanguageCountry.run()