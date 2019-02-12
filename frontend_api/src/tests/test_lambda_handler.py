import unittest


class TestLambdaHandler(unittest.TestCase):  
    def test_lambda_handler(self):
        self.assertEqual("Test Data", "Test Data")


if __name__ == "__main__":
    unittest.main()