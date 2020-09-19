using System.Globalization;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
namespace SullTec.Common.PowerShell
{
    public class SemVer
    {
        private int major;
        public int Major {
            get { return this.major; }
            set { this.major = Math.Abs(value); }
        }
        private int minor;
        public int Minor {
            get { return this.minor; }
            set { this.minor = Math.Abs(value); }
        }
        private int patch;
        public int Patch {
            get { return this.patch; }
            set { this.patch = Math.Abs(value); }
        }
        private string[] preRelease;
        public string PreRelease {
            get {
                if (this.preRelease.Length > 0) {
                    return String.Join('.', this.preRelease);
                }
                else { return ""; }
            }
            set {
                value = Regex.Replace(value, @"(?ms)[^0-9A-Za-z\-\.]",".");
                value = Regex.Replace(value, @"\.{2,}",".");
                this.preRelease = value.Split('.');
            }
        }
        private string[] buildMetadata;
        public string BuildMetadata { 
            get {
                if (this.buildMetadata.Length > 0) {
                    return String.Join('.', this.buildMetadata);
                }
                else { return ""; }
            }
            set {
                value = Regex.Replace(value, @"(?ms)[^0-9A-Za-z\-\.]",".");
                value = Regex.Replace(value, @"\.{2,}",".");
                this.buildMetadata = value.Split('.');
            }
        }
        //private static string VersionMatch { get; }
        private static Regex VersionMatch = new Regex(@"^([vV]([eE][rR])?\.?)?(?<major>0|[1-9]\d*)(\.(?<minor>0|[1-9]\d*)(\.(?<patch>0|[1-9]\d*))?)?(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$");
        private void Init (
            int Major,
            int Minor,
            int Patch,
            string PreRelease,
            string BuildMetadata
        ) {
            this.Major         = Major;
            this.Minor         = Minor;
            this.Patch         = Patch;
            this.PreRelease    = PreRelease;
            this.BuildMetadata = BuildMetadata;
        }
        private void Init (string Value) {
            Value = Regex.Replace(Value,"(?ms)[\x00-\x1f\x7f]","").Trim();
            MatchCollection currentMatches = SemVer.VersionMatch.Matches(Value.Trim());
            foreach (Match currentMatch in currentMatches) {
                if (currentMatch.Success) {
                    this.Init(
                        Convert.ToInt32(currentMatch.Groups["major"].Value),
                        Convert.ToInt32(currentMatch.Groups["minor"].Value),
                        Convert.ToInt32(currentMatch.Groups["patch"].Value),
                        currentMatch.Groups["prerelease"].Value,
                        currentMatch.Groups["buildmetadata"].Value
                    );
                    break;
                }
            }

        }
        public SemVer () { this.Init(0, 0, 0, "", ""); }
        public SemVer (
            int Major,
            int Minor,
            int Patch,
            string PreRelease,
            string BuildMetadata
        ) {
            this.Init (Major, Minor, Patch, PreRelease, BuildMetadata);
        }
        public SemVer(string Value)   { this.Init(Value); }
        public SemVer(string[] Value) { this.Init(String.Join("",Value)); }
        public SemVer(object[] Value) { this.Init(String.Join("",Value)); }

        public bool HasPreRelease (){ return !string.IsNullOrWhiteSpace(this.PreRelease); }
        public bool HasBuildMetadata () { return !string.IsNullOrWhiteSpace(this.BuildMetadata); }
        public override string ToString(){
            return SemVer.ToString(this);
        }
        public static string ToString (SemVer Value) {
            string semverString = "";
            semverString += Convert.ToString(Value.Major);
            semverString += "." + Convert.ToString(Value.Minor);
            semverString += "." + Convert.ToString(Value.Patch);
            semverString += Value.HasPreRelease() ? "-" + Value.PreRelease : "";
            semverString += Value.HasBuildMetadata() ? "+" + Value.BuildMetadata : "";
            return semverString;
        }
        public static SemVer[] ConvertTo (string Value) {
            List<SemVer> returnSemVer = new List<SemVer>();
            Value = Regex.Replace(Value,"(?ms)[\x00-\x1f\x7f]","").Trim();
            MatchCollection currentMatches = SemVer.VersionMatch.Matches(Value);
            foreach (Match currentMatch in currentMatches) {
                if (currentMatch.Success) {
                     returnSemVer.Add(new SemVer(
                        Convert.ToInt32(currentMatch.Groups["major"].Value),
                        Convert.ToInt32(currentMatch.Groups["minor"].Value),
                        Convert.ToInt32(currentMatch.Groups["patch"].Value),
                        currentMatch.Groups["prerelease"].Value,
                        currentMatch.Groups["buildmetadata"].Value
                    ));
                }
            }
            return returnSemVer.ToArray();
        }
        public bool CompareTo (SemVer Value) {
            return SemVer.Compare(this, Value);
        }
        public bool CompareTo (string Value) {
            return SemVer.Compare(this,SemVer.ConvertTo(Value)[0]);
        }
        public static bool Compare (SemVer Value1, SemVer Value2) {
            if (Value1.Major > Value2.Major) { return true; }
		    else if (Value1.Major == Value2.Major) {
			    if (Value1.Minor > Value2.Minor) { return true; }
			    else if (Value1.Minor == Value2.Minor) {
				    if (Value1.Patch > Value2.Patch) { return true; }
				    else if (Value1.Patch == Value2.Patch) {
					    if (Value1.HasPreRelease() & Value2.HasPreRelease()) {
                            int shortestSet = Value1.preRelease.Length <= Value2.preRelease.Length ? Value1.preRelease.Length : Value2.preRelease.Length;
                            for (int counter = 0; counter < shortestSet; counter++) {
                                Int64 intVal1 = 0;
                                Int64 intVal2 = 0;
                                if (Int64.TryParse(Value1.preRelease[counter],out intVal1) && Int64.TryParse(Value2.preRelease[counter],out intVal2)) {
                                    if      (intVal1 > intVal2) { return true;  }
                                    else if (intVal1 < intVal2) { return false; }
                                }
                                else {
                                    int lexicalCompare = String.Compare(Value1.preRelease[counter],Value2.preRelease[counter],CultureInfo.CurrentCulture,CompareOptions.IgnoreCase);
                                    if      (lexicalCompare > 0) { return true;  }
                                    else if (lexicalCompare < 0) { return false; }
                                }
                            }
                            if (Value1.preRelease.Length > Value2.preRelease.Length) { return true; } //They are completely equal upto the point Value1 has more release data.
                            else { return false; } // They are completely equal, or Value 2 has more release data, therefore Value1 is not greater than Value 2.
                        }
                        else if (!Value1.HasPreRelease() & Value2.HasPreRelease()) { return true; }
                       else { return false; }
                   }
                   else { return false; }
                }
                else { return false; }
            }
            else { return false; }
        }
    }
}