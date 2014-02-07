# coding: utf-8
def parse_time():
    import pandas as pd

    df = pd.read_table("./runtime/time_cpus.txt",
                   names = ["time_type", "time"])

    real = []
    for string in df[df["time_type"] == "real"]["time"]:
        (temp_m, temp_s) = string.split("m")
        (temp_s, s_dp) = temp_s.split(".")
        real.append(int(temp_m) * 60. + float(temp_s + "." + s_dp[:3]))

    user = []
    for string in df[df["time_type"] == "user"]["time"]:
        (temp_m, temp_s) = string.split("m")
        (temp_s, s_dp) = temp_s.split(".")
        user.append(int(temp_m) * 60. + float(temp_s + "." + s_dp[:3]))

    sys = []
    for string in df[df["time_type"] == "sys"]["time"]:
        (temp_m, temp_s) = string.split("m")
        (temp_s, s_dp) = temp_s.split(".")
        sys.append(int(temp_m) * 60. + float(temp_s + "." + s_dp[:3]))

    new_df = pd.DataFrame(real, columns=['real'])
    new_df["user"] = pd.DataFrame(user)
    new_df["sys"] = pd.DataFrame(sys)

    return new_df

if __name__ == "__main__":
    parse_time()
