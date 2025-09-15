import pytest
from math_utils import add, subtract

@pytest.fixture
def sample_numbers():
    return 10, 5

def test_add_with_fixture(sample_numbers):
    a, b = sample_numbers
    assert add(a, b) == 15

def test_subtract_with_fixture(sample_numbers):
    a, b = sample_numbers
    assert subtract(a, b) == 5
