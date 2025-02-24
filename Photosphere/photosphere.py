import os
import cv2

#Notes from Hailey...
#this code works for a single stream, code will need to be adjusted for multiple
#the sticher logic will also need to be altered since, images need to be sitched in a certain order
#ALSO an error message does result when the program is done running, but ignore that for now. I am not sure why that message is appearing.

#pulls video stream
stream_url = "http://192.168.0.100:8080/stream"

cap = cv2.VideoCapture(stream_url)

#error message if steam is not working
if not cap.isOpened():
    print("Error: Could not open stream.")
    exit()

# Create a directory to save snapshots
output_dir = "snapshots"
os.makedirs(output_dir, exist_ok=True)

#counts the number of photos taken
frame_count = 0

while True:
    # Read a frame from the stream
    ret, frame = cap.read()

    if not ret:
        print("Error: Failed to read frame.")
        break

    # Display the frame in a window
    cv2.imshow('Stream', frame)

    # takes a photo when 's' is pressed
    key = cv2.waitKey(1) & 0xFF
    if key == ord('s'): 
        frame_count += 1
        snapshot_path = os.path.join(output_dir, f"snapshot_{frame_count}.jpg")
        cv2.imwrite(snapshot_path, frame)
        print(f"Snapshot saved: {snapshot_path}")

        # press 'q' to exit
    if key == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()



while True:
    # Read a frame from the stream
    ret, frame = cap.read()

    if not ret:
        print("Error: Failed to read frame.")
        break


# Release the stream and close the window
cap.release()
cv2.destroyAllWindows()

#---------------------------------------------------------------------------------------------------------------------------------------#

def stitch_images(images):
    
    # Create the stitcher object
    stitcher = cv2.createStitcher() if int(cv2.__version__.split('.')[0]) < 4 else cv2.Stitcher_create()

    # Perform stitching
    status, stitched = stitcher.stitch(images)

    if status != cv2.Stitcher_OK:
        print(f"Error during stitching: {status}")
        return None

    return stitched

#to store file path
file_name = []

for i in range(1, frame_count+1):
    file_name.append(f"snapshots/snapshot_{i}.jpg")

#to store loaded images
images = []

for path in file_name:
  img = cv2.imread(path)
  if img is not None:
    images.append(img)
  else:
    print(f"Error loading image: {file_name}")

#caller sticher
result = stitch_images(images)
if result is not None:
    # Show the stitched panorama in a window (the image is not the best when loaded)
    cv2.imshow("360° Panorama", result)

    # Save the result as an image (image looks better from the downloaded image)
    cv2.imwrite("360_panorama.jpg", result)
    print("360° panorama saved as '360_panorama.jpg'.")

    # Wait for a key press and close all OpenCV windows
    cv2.waitKey(0)
    cv2.destroyAllWindows()
else:
    print("Stitching failed. No output generated.")



