import argparse
import os
import shutil
import subprocess
import filecmp
import sys

def compile_suite():
    print("Compiling test suite...")
    if os.path.exists("tests/output"):
        shutil.rmtree("tests/output")
    os.makedirs("tests/output")
    
    cmd = [
        "typst", "compile", 
        "--root", ".", 
        "tests/suite.typ", 
        "tests/output/page-{n}.png"
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print("Compilation failed!")
        print(result.stderr)
        sys.exit(1)
    print("Compilation successful.")

def update_baseline():
    print("Updating baseline...")
    if os.path.exists("tests/baseline"):
        shutil.rmtree("tests/baseline")
    shutil.copytree("tests/output", "tests/baseline")
    print("Baseline updated.")

def compare_images():
    print("Comparing output with baseline...")
    files = sorted(os.listdir("tests/output"))
    
    if not os.path.exists("tests/baseline"):
        print("Error: No baseline found. Run with --update first.")
        sys.exit(1)
        
    baseline_files = sorted(os.listdir("tests/baseline"))
    
    if files != baseline_files:
        print(f"Error: File count/names mismatch.\nOutput: {files}\nBaseline: {baseline_files}")
        sys.exit(1)
        
    failed = False
    for f in files:
        output_path = os.path.join("tests/output", f)
        baseline_path = os.path.join("tests/baseline", f)
        
        if not filecmp.cmp(output_path, baseline_path, shallow=False):
            print(f"FAIL: {f} differs from baseline.")
            failed = True
        else:
            print(f"PASS: {f}")
            
    if failed:
        sys.exit(1)
    else:
        print("All tests passed.")

def main():
    parser = argparse.ArgumentParser(description="Visual regression tests")
    parser.add_argument("--update", action="store_true", help="Update baseline images")
    args = parser.parse_args()
    
    compile_suite()
    
    if args.update:
        update_baseline()
    else:
        compare_images()

if __name__ == "__main__":
    main()
