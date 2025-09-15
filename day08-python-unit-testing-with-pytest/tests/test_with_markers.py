import pytest
from math_utils import multiply, divide

@pytest.mark.slow
def test_large_multiplication():
    result = multiply(1000, 2000)
    assert result == 2000000

@pytest.mark.integration
def test_integration_divide():
    assert divide(100, 5) == 20
